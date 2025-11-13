// routes/bot.js
const express = require('express');
const asyncHandler = require('express-async-handler');
const router = express.Router();
const Product = require('../model/product');

router.post(
  '/query',
  asyncHandler(async (req, res) => {
    const q = (req.body.q || '').toLowerCase().trim();

    if (!q) {
      return res.json({ answer: 'Please ask me about a product!' });
    }

    if (q.includes('develop') || q.includes('nexbuy') || q.includes('about')) {
      return res.json({
        answer:
          'NexBuy is a smart e-commerce platform offering a wide range of products with secure payment options and fast delivery which developed by Tanny and Brothers!',
      });
    }

    const product = await Product.findOne({
      name: { $regex: q, $options: 'i' },
    });

    if (product) {
      const stockQty = product.quantity ?? 0;
      const availability =
        stockQty > 0
          ? ` In Stock (${stockQty} available)`
          : ' Out of Stock';

      return res.json({
        answer: `${product.name} — ${availability}\n Price: $${product.price}\n Details: ${
          product.description || 'No details available.'
        }`,
      });
    }

    return res.json({
      answer:
        "Sorry, I couldn't find that product. Try asking like: 'Is iPhone 13 available?'",
    });
  })
);

module.exports = router;
