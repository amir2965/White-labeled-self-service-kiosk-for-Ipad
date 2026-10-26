import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/models/settlement.dart';
import '../../domain/models/payout_status.dart';

/// Professional PDF export service for transfer history
class PdfExportService {
  /// Generates a professionally designed PDF report for transfer history
  static Future<void> generateTransferHistoryPdf({
    required List<Settlement> settlements,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final now = DateTime.now();

    // Calculate summary statistics
    final totalGross = settlements.fold<double>(
      0,
      (sum, s) => sum + s.gross.minorUnits / 100,
    );
    final totalFees = settlements.fold<double>(
      0,
      (sum, s) => sum + s.fees.minorUnits / 100,
    );
    final totalGst = settlements.fold<double>(
      0,
      (sum, s) => sum + s.gst.minorUnits / 100,
    );
    final totalNetPaid = settlements.fold<double>(
      0,
      (sum, s) => sum + s.netPaid.minorUnits / 100,
    );

    // Create PDF pages
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header Section
          _buildHeader(dateFormat, startDate, endDate, now),
          pw.SizedBox(height: 30),

          // Summary Cards
          _buildSummarySection(
            totalGross,
            totalFees,
            totalGst,
            totalNetPaid,
            currencyFormat,
          ),
          pw.SizedBox(height: 30),

          // Transfer History Table
          _buildTransferHistoryTable(settlements, dateFormat, currencyFormat),
          pw.SizedBox(height: 20),

          // Footer with metadata
          pw.Spacer(),
          _buildFooter(settlements.length, now),
        ],
      ),
    );

    // Show native print/preview dialog
    // This works better on iPad - users can preview, save to Files, print, or share
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name:
          'Transfer_History_${dateFormat.format(startDate)}_to_${dateFormat.format(endDate)}.pdf',
      format: PdfPageFormat.a4,
    );
  }

  /// Builds the PDF header with title and date range
  static pw.Widget _buildHeader(
    DateFormat dateFormat,
    DateTime startDate,
    DateTime endDate,
    DateTime generatedDate,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Title
        pw.Text(
          'Transfer History Report',
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 8),

        // Date range
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Report Period',
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Generated',
                  style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  dateFormat.format(generatedDate),
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),

        pw.SizedBox(height: 15),
        pw.Divider(color: PdfColors.blue900, thickness: 2),
      ],
    );
  }

  /// Builds the summary section with key metrics
  static pw.Widget _buildSummarySection(
    double totalGross,
    double totalFees,
    double totalGst,
    double totalNetPaid,
    NumberFormat currencyFormat,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.blue200, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryCard(
                'Gross Amount',
                totalGross,
                currencyFormat,
                PdfColors.green700,
              ),
              _buildSummaryCard(
                'Fees',
                totalFees,
                currencyFormat,
                PdfColors.orange700,
              ),
              _buildSummaryCard(
                'GST',
                totalGst,
                currencyFormat,
                PdfColors.purple700,
              ),
              _buildSummaryCard(
                'Net Paid',
                totalNetPaid,
                currencyFormat,
                PdfColors.blue900,
                isHighlighted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual summary card
  static pw.Widget _buildSummaryCard(
    String label,
    double amount,
    NumberFormat currencyFormat,
    PdfColor color, {
    bool isHighlighted = false,
  }) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: isHighlighted ? PdfColors.blue900 : PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(
          color: isHighlighted ? PdfColors.blue900 : PdfColors.grey300,
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              color: isHighlighted ? PdfColors.white : PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            currencyFormat.format(amount),
            style: pw.TextStyle(
              fontSize: isHighlighted ? 15 : 14,
              fontWeight: pw.FontWeight.bold,
              color: isHighlighted ? PdfColors.white : color,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the transfer history table
  static pw.Widget _buildTransferHistoryTable(
    List<Settlement> settlements,
    DateFormat dateFormat,
    NumberFormat currencyFormat,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Transfer Details',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.2),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(1.2),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(0.8),
            5: const pw.FlexColumnWidth(1.2),
            6: const pw.FlexColumnWidth(1.2),
          },
          children: [
            // Table header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableHeader('Date'),
                _buildTableHeader('Period'),
                _buildTableHeader('Gross'),
                _buildTableHeader('Fees'),
                _buildTableHeader('GST'),
                _buildTableHeader('Net Paid'),
                _buildTableHeader('Status'),
              ],
            ),

            // Table rows
            ...settlements.map((settlement) {
              final periodStart = DateFormat(
                'dd MMM',
              ).format(settlement.periodStart);
              final periodEnd = DateFormat(
                'dd MMM',
              ).format(settlement.periodEnd);

              return pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: settlements.indexOf(settlement) % 2 == 0
                      ? PdfColors.white
                      : PdfColors.grey50,
                ),
                children: [
                  _buildTableCell(dateFormat.format(settlement.createdAt)),
                  _buildTableCell('$periodStart - $periodEnd'),
                  _buildTableCell(
                    currencyFormat.format(settlement.gross.minorUnits / 100),
                  ),
                  _buildTableCell(
                    currencyFormat.format(settlement.fees.minorUnits / 100),
                  ),
                  _buildTableCell(
                    currencyFormat.format(settlement.gst.minorUnits / 100),
                  ),
                  _buildTableCell(
                    currencyFormat.format(settlement.netPaid.minorUnits / 100),
                    isBold: true,
                  ),
                  _buildTableCell(
                    settlement.status.displayName,
                    color: _getStatusColor(settlement.status),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  /// Builds table header cell
  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  /// Builds table data cell
  static pw.Widget _buildTableCell(
    String text, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.grey900,
        ),
      ),
    );
  }

  /// Builds footer with metadata
  static pw.Widget _buildFooter(int totalTransfers, DateTime generatedDate) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 15),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Total Transfers: $totalTransfers',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            'Generated: ${DateFormat('dd MMM yyyy HH:mm').format(generatedDate)}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Gets color for settlement status
  static PdfColor _getStatusColor(PayoutStatus status) {
    switch (status) {
      case PayoutStatus.paid:
        return PdfColors.green700;
      case PayoutStatus.pending:
        return PdfColors.orange700;
      case PayoutStatus.processing:
        return PdfColors.blue700;
      case PayoutStatus.failed:
        return PdfColors.red700;
      case PayoutStatus.reversed:
        return PdfColors.grey700;
    }
  }
}
