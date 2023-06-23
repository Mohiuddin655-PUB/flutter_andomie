part of 'enums.dart';

enum ActionType {
  none(''),
  add('Add'),
  confirm('Confirm'),
  cancel('Cancel'),
  change('Change'),
  choose('Choose'),
  delete('Delete'),
  edit('edit'),
  no('No'),
  remove('Remove'),
  tryAgain('Try Again'),
  skip('Skip'),
  update('Update'),
  yes('Yes');

  final String value;

  const ActionType(this.value);
}
