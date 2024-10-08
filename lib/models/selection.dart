class Selection<T> {
  final bool selected;
  final String id;
  final T data;

  const Selection({
    this.selected = false,
    required this.id,
    required this.data,
  });

  Selection<T> update(bool selected) {
    return Selection(
      id: id,
      data: data,
      selected: selected,
    );
  }

  @override
  int get hashCode => id.hashCode ^ selected.hashCode ^ data.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Selection<T> && id == other.id;
  }
}
