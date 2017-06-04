$(document).ready ->
  $(".ui.dropdown").dropdown()
  # 日期选择
  $(".datepicker").datetimepicker
    format: 'YYYY-MM-DD'
  $(".datetimepicker").datetimepicker
    format: 'YYYY-MM-DD h:mm:ss a'
  $(".timepicker").datetimepicker
    format: 'hh:mm:ss a'
