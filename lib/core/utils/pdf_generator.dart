import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:nuveta_patient_app/features/prescriptions/data/models/prescription_model.dart';
import 'package:nuveta_patient_app/features/lab_tests/data/models/lab_test_model.dart';

Future<void> exportPrescriptionPdf(BuildContext context, PrescriptionModel p) async {
  final doc = pw.Document();
  final primary = Theme.of(context).colorScheme.primary;
  doc.addPage(
    pw.MultiPage(
      build: (context) => [
        // Clinic header
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Nuveta Clinic', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('123 Health Ave • City, Country', style: pw.TextStyle(fontSize: 9)),
                  pw.Text('Tel: (555) 123-4567', style: pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.Text('Rx', style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ),

        pw.SizedBox(height: 6),

        // Patient and date row
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Patient:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('Patient Name', style: pw.TextStyle(fontSize: 11)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Date:', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('${p.prescribedDate.toLocal().toIso8601String().split("T").first}', style: pw.TextStyle(fontSize: 11)),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 8),

        // Medication box
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: pdf.PdfColor.fromInt(primary.value)),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(p.medicationName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Text('Dosage: ${p.dosage}', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Frequency: ${p.frequency}', style: pw.TextStyle(fontSize: 11)),
              pw.Text('Quantity: ${p.quantity}', style: pw.TextStyle(fontSize: 11)),
              pw.SizedBox(height: 8),
              pw.Text('Instructions:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(p.instructions, style: pw.TextStyle(fontSize: 10)),
            ],
          ),
        ),

        pw.SizedBox(height: 12),

        // Doctor and signature row
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Prescribed by', style: pw.TextStyle(fontSize: 9, color: pdf.PdfColors.grey800)),
                pw.SizedBox(height: 4),
                pw.Text(p.doctorName, style: pw.TextStyle(fontSize: 11)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Container(width: 120, height: 1, color: pdf.PdfColors.grey400),
                pw.SizedBox(height: 4),
                pw.Text('Signature', style: pw.TextStyle(fontSize: 9, color: pdf.PdfColors.grey600)),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 18),

        // Footer with clinic info
        pw.Divider(),
        pw.SizedBox(height: 6),
        pw.Center(child: pw.Text('Nuveta Clinic • 123 Health Ave • Tel: (555) 123-4567', style: pw.TextStyle(fontSize: 9, color: pdf.PdfColors.grey600))),
      ],
    ),
  );

  final bytes = await doc.save();
  await Printing.layoutPdf(onLayout: (_) => bytes);
}

Future<void> exportLabTestPdf(BuildContext context, LabTestModel t) async {
  final doc = pw.Document();
  final primary = Theme.of(context).colorScheme.primary;

  doc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Lab Test Result', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 8),
                    pw.Text(t.testName, style: pw.TextStyle(fontSize: 18)),
                  ],
                ),
                pw.Text('Date: ${t.testDate.toLocal().toIso8601String().split("T").first}'),
              ],
            ),

            pw.SizedBox(height: 12),

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: pdf.PdfColor.fromInt(primary.value)),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Lab: ${t.labName}'),
                  pw.SizedBox(height: 6),
                  pw.Text('Doctor review:'),
                  pw.Text(t.doctorReview),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            pw.Text('Results', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),

            pw.Table.fromTextArray(
              data: <List<String>>[
                <String>['Test', 'Value', 'Unit', 'Normal'],
                ...t.results.entries.map((e) => [e.key, e.value['value'].toString(), e.value['unit'].toString(), e.value['normal'].toString()])
              ],
            ),
          ],
        ),
      ],
    ),
  );

  final bytes = await doc.save();
  await Printing.layoutPdf(onLayout: (_) => bytes);
}
