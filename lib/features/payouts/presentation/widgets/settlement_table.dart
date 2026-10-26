import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/settlement.dart';
import 'status_pill.dart';
import '../../../../presentation/analytics/theme_provider.dart';

/// Settlement data table with pagination and sorting
class SettlementTable extends ConsumerStatefulWidget {
  final List<Settlement> settlements;
  final Function(Settlement) onRowTap;

  const SettlementTable({
    Key? key,
    required this.settlements,
    required this.onRowTap,
  }) : super(key: key);

  @override
  ConsumerState<SettlementTable> createState() => _SettlementTableState();
}

class _SettlementTableState extends ConsumerState<SettlementTable> {
  int _sortColumnIndex = 0;
  bool _sortAscending = false;
  final int _rowsPerPage = 20;
  int _currentPage = 0;

  List<Settlement> get _sortedSettlements {
    final sorted = List<Settlement>.from(widget.settlements);

    switch (_sortColumnIndex) {
      case 0: // Date
        sorted.sort(
          (a, b) => _sortAscending
              ? a.createdAt.compareTo(b.createdAt)
              : b.createdAt.compareTo(a.createdAt),
        );
        break;
      case 5: // Net Paid
        sorted.sort(
          (a, b) => _sortAscending
              ? a.netPaid.minorUnits.compareTo(b.netPaid.minorUnits)
              : b.netPaid.minorUnits.compareTo(a.netPaid.minorUnits),
        );
        break;
    }

    return sorted;
  }

  List<Settlement> get _paginatedSettlements {
    final sorted = _sortedSettlements;
    final start = _currentPage * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, sorted.length);
    return sorted.sublist(start, end);
  }

  int get _totalPages => (widget.settlements.length / _rowsPerPage).ceil();

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final periodFormatter = DateFormat('dd MMM');
    final isDarkMode = ref.watch(themeModeProvider);

    return Column(
      children: [
        // Table
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.15)
                  : Colors.grey.shade300,
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 48,
              ),
              child: DataTable(
                showCheckboxColumn: false,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                headingRowColor: MaterialStateProperty.all(
                  isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.shade50,
                ),
                headingTextStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.7)
                      : Colors.grey.shade700,
                ),
                dataRowHeight: 64,
                columns: [
                  DataColumn(label: const Text('DATE'), onSort: _onSort),
                  const DataColumn(label: Text('SETTLEMENT PERIOD')),
                  const DataColumn(label: Text('GROSS'), numeric: true),
                  const DataColumn(label: Text('FEES'), numeric: true),
                  const DataColumn(label: Text('GST'), numeric: true),
                  DataColumn(
                    label: const Text('NET PAID'),
                    numeric: true,
                    onSort: _onSort,
                  ),
                  const DataColumn(label: Text('STATUS')),
                ],
                rows: _paginatedSettlements.map((settlement) {
                  return DataRow(
                    onSelectChanged: (_) => widget.onRowTap(settlement),
                    cells: [
                      DataCell(
                        Text(
                          dateFormatter.format(settlement.createdAt),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${periodFormatter.format(settlement.periodStart)} - ${periodFormatter.format(settlement.periodEnd)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          settlement.gross.formatted,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          settlement.fees.formatted,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          settlement.gst.formatted,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          settlement.netPaid.formatted,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      DataCell(StatusPill(status: settlement.status)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Pagination controls
        if (_totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${_currentPage * _rowsPerPage + 1}-${((_currentPage + 1) * _rowsPerPage).clamp(0, widget.settlements.length)} of ${widget.settlements.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.6)
                      : Colors.grey.shade600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: _currentPage > 0
                          ? (isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black87)
                          : (isDarkMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade400),
                    ),
                  ),
                  Text(
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: _currentPage < _totalPages - 1
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.chevron_right,
                      color: _currentPage < _totalPages - 1
                          ? (isDarkMode
                                ? Colors.white.withOpacity(0.7)
                                : Colors.black87)
                          : (isDarkMode
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
