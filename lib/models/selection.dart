class Selection<T> {
  final bool selected;
  final bool loading;
  final String id;
  final T data;

  const Selection({
    this.selected = false,
    this.loading = false,
    required this.id,
    required this.data,
  });

  Selection<T> get reverse => copy(selected: !selected);

  Selection<T> copy({
    bool? selected,
    bool? loading,
    String? id,
    T? data,
  }) {
    return Selection(
      id: id ?? this.id,
      data: data ?? this.data,
      loading: loading ?? this.loading,
      selected: selected ?? this.selected,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^ loading.hashCode ^ selected.hashCode ^ data.hashCode;
  }

  @override
  bool operator ==(Object other) => other is Selection<T> && id == other.id;
}
