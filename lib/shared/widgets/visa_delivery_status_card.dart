import 'package:flutter/material.dart';

class VisaDeliveryStatusCard extends StatelessWidget {
  const VisaDeliveryStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Progress Row
                Row(
                  children: [
                    const Text(
                      "On time",
                      style: TextStyle(color: Colors.green),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                const Text(
                  "India Tourist eVisa",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Need it sooner?",
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),

                const SizedBox(height: 12),

                /// Progress Bar with airplane
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    /// Background track
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    /// Progress line
                    FractionallySizedBox(
                      widthFactor: 0.3,

                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    /// Plane icon
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.3 * 0.75,
                      child: Image.asset(
                        "assets/icons/fly.png",
                        width: 24,
                        height: 50,
                      ),
                    ),

                    /// Flag circle
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "🇮🇳",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          /// RIGHT DATE CARD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
              color: Colors.green.withOpacity(0.05),
            ),
            child: Column(
              children: const [
                Text("Est. delivery", style: TextStyle(fontSize: 12)),
                SizedBox(height: 4),
                Text(
                  "Jan 31",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text("9:26 pm", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
