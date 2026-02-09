import 'package:flutter/material.dart';
import 'package:register_visa_web_app/features/home/domain/testimonial_card.dart';

class TestimonialCard extends StatelessWidget {
  final Testimonial data;

  const TestimonialCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Quote Icon
          Icon(Icons.format_quote_rounded, size: 40, color: Colors.indigo.withValues(alpha: 0.2)),

          const SizedBox(height: 8),

          /// Message
          Text(
            data.message,
            style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
            overflow: TextOverflow.visible,
            maxLines: 3,
          ),
          //if (width > 1455)
          /// Stars
          Expanded(
            child: Row(
              children: List.generate(
                5,
                (index) => Icon(index < data.rating ? Icons.star_rounded : Icons.star_border_rounded, color: Colors.amber, size: 18),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// User Info
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.indigo,
                  child: Text(
                    data.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name, style: const TextStyle(fontWeight: FontWeight.w600)),

                    Text('${data.visaType} • ${data.timeAgo}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
