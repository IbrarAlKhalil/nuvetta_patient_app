import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:intl/intl.dart';

class TelehealthSessionPage extends StatefulWidget {
  final Map<String, dynamic>? appointment;

  const TelehealthSessionPage({super.key, this.appointment});

  @override
  State<TelehealthSessionPage> createState() => _TelehealthSessionPageState();
}

class _TelehealthSessionPageState extends State<TelehealthSessionPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  bool _micEnabled = true;
  bool _cameraEnabled = true;

  @override
  void initState() {
    super.initState();
    _initRenderer();
  }

  Future<void> _initRenderer() async {
    await _localRenderer.initialize();
    await _openUserMedia();
  }

  Future<void> _openUserMedia() async {
    try {
      final stream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'facingMode': 'user',
        },
      });

      _localStream = stream;
      _localRenderer.srcObject = stream;
      setState(() {});
    } catch (error) {
      debugPrint('Unable to access camera/microphone: $error');
    }
  }

  void _toggleMic() {
    if (_localStream == null) return;
    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isEmpty) return;
    final enabled = !audioTracks.first.enabled;
    audioTracks.first.enabled = enabled;
    setState(() {
      _micEnabled = enabled;
    });
  }

  void _toggleCamera() {
    if (_localStream == null) return;
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isEmpty) return;
    final enabled = !videoTracks.first.enabled;
    videoTracks.first.enabled = enabled;
    setState(() {
      _cameraEnabled = enabled;
    });
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final doctorName = appointment?['doctorName'] ?? 'Your provider';
    final dateTime = appointment?['dateTime'] as DateTime?;
    final formattedDate = dateTime != null
        ? DateFormat('EEE, dd MMM yyyy · hh:mm a').format(dateTime)
        : 'Scheduled time';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telehealth Video Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              doctorName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  child: _localStream == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : RTCVideoView(
                          _localRenderer,
                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          mirror: true,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Your camera is live. This page shows your local preview for the telehealth session.',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleMic,
                  icon: Icon(_micEnabled ? Icons.mic : Icons.mic_off),
                  label: Text(_micEnabled ? 'Mute' : 'Unmute'),
                ),
                ElevatedButton.icon(
                  onPressed: _toggleCamera,
                  icon: Icon(_cameraEnabled ? Icons.videocam : Icons.videocam_off),
                  label: Text(_cameraEnabled ? 'Camera Off' : 'Camera On'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('End Call'),
            ),
          ],
        ),
      ),
    );
  }
}
