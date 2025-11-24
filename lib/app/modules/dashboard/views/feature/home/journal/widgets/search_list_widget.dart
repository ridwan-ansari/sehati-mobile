import 'package:flutter/material.dart';

class SearchListWidget<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T) onItemSelected;
  final void Function(T)? onAddPressed;
  final Function(String)? onSearch;
  final TextEditingController? searchC;

  const SearchListWidget({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onItemSelected,
    this.onAddPressed,
    this.onSearch,
    this.searchC,
  });

  @override
  State<SearchListWidget<T>> createState() => _SearchListWidgetState<T>();
}

class _SearchListWidgetState<T> extends State<SearchListWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: widget.searchC,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintText: "Search food...",
                hintStyle: const TextStyle(color: Colors.grey),
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.search, size: 24),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // LIST
          Flexible(
            flex: widget.items.isEmpty ?0:1,
            child: widget.items.isEmpty
                ? const Center(
                    child: Text(
                      "",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];

                      return ListTile(
                        onTap: () => widget.onItemSelected(item),
                        title: Text(
                          widget.itemLabel(item),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: widget.onAddPressed != null
                              ? () => widget.onAddPressed!(item)
                              : null,

                          icon: const Icon(Icons.add, size: 22),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
