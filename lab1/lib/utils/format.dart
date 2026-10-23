/// R8: свой форматтер, без пакетов. Результат: "18 Oct, 10:00".
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _two(int n) => n.toString().padLeft(2, '0');

String formatDateTime(DateTime d) =>
    '${d.day} ${_months[d.month - 1]}, ${_two(d.hour)}:${_two(d.minute)}';