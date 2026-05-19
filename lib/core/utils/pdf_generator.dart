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
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
            border: pw.Border.all(color: pdf.PdfColor.fromInt(primary.value)),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Prescription', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 8),
                      pw.Text(p.medicationName, style: pw.TextStyle(fontSize: 18)),
                    ],
                  ),
                  pw.Text('Date: ${p.prescribedDate.toLocal().toIso8601String().split("T").first}'),
                ],
              ),

              pw.SizedBox(height: 12),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Dosage: ${p.dosage}'),
                  pw.Text('Frequency: ${p.frequency}'),
                ],
              ),

              pw.SizedBox(height: 12),

              pw.Text('Doctor: ${p.doctorName}'),
              pw.SizedBox(height: 8),
              pw.Text('Purpose: ${p.purpose}'),
              pw.SizedBox(height: 8),
              pw.Text('Instructions:'),
              pw.Text(p.instructions),

              pw.SizedBox(height: 16),

              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: pdf.PdfColor.fromInt(primary.withOpacity(0.06).value),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text('Refills left: ${p.refillsLeft}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
            ],
          ),
        ),
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
