import 'package:flutter/material.dart';

class PharmacyPage extends StatelessWidget {
  const PharmacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = const [
      {
        "name": "Paracetamol 500mg",
        "price": "5.00",
        "category": "Pain Relief",
      },
      {
        "name": "Amoxicillin 250mg",
        "price": "12.00",
        "category": "Antibiotic",
      },
      {
        "name": "Vitamin C Tablets",
        "price": "8.50",
        "category": "Vitamins",
      },
      {
        "name": "Cough Syrup",
        "price": "6.75",
        "category": "Cold & Flu",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacy"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cart coming soon")),
              );
            },
          ),
        ],
      ),

      // ================= SAFE BODY =================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ================= SEARCH =================
              TextField(
                decoration: InputDecoration(
                  hintText: "Search medicines...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ================= CATEGORY =================
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryChip(label: "All"),
                    _CategoryChip(label: "Pain Relief"),
                    _CategoryChip(label: "Antibiotics"),
                    _CategoryChip(label: "Vitamins"),
                    _CategoryChip(label: "Cold & Flu"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= LIST =================
              Expanded(
                child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final item = medicines[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // ================= ICON =================
                            const CircleAvatar(
                              child: Icon(Icons.medication),
                            ),

                            const SizedBox(width: 12),

                            // ================= INFO =================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item["name"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item["category"]!,
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ================= PRICE + BUTTON (FIXED) =================
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "\$${item["price"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      minimumSize: const Size(0, 30),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${item["name"]} added to cart",
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= CATEGORY CHIP =================
class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}