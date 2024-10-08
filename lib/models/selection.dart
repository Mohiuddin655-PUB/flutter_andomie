class Selection<T> {
  final bool selected;
  final String id;
  final T data;

  const Selection({
    this.selected = false,
    required this.id,
    required this.data,
  });

  Selection<T> get reverse => copy(selected: !selected);

  Selection<T> copy({
    bool? selected,
    String? id,
    T? data,
  }) {
    return Selection(
      id: id ?? this.id,
      data: data ?? this.data,
      selected: selected ?? this.selected,
    );
  }

  @override
  int get hashCode => id.hashCode ^ selected.hashCode ^ data.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Selection<T> && id == other.id;
  }
}
