const express = require("express");
const asyncHandler = require("express-async-handler");
const router = express.Router();
const multer = require("multer");
const Product = require("../model/product");
const Order = require("../model/order");
const path = require("path");
const fs = require("fs");
const Jimp = require("jimp");

// ------------------ File Upload ------------------
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadPath = path.join(__dirname, "../uploads/bot");
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "_" + file.originalname);
  },
});
const upload = multer({ storage });

// ------------------ TEXT QUERY ------------------
router.post(
  "/query",
  asyncHandler(async (req, res) => {
    const q =
      (req.body.q ||
        req.body.message ||
        req.body.text ||
        "")
        .toString()
        .toLowerCase()
        .trim();

    const userId = req.body.userId || req.body.userID || null;

    if (!q) {
      return res.json({
        answer:
          "Please ask about a product or your order. Example:\n• Is iPhone 13 available?\n• My iPhone 12 Pro order details?",
      });
    }

    // ------------ ORDER TRACKING ------------
    if (/(track|order|my order|order details)/i.test(q)) {
      if (!userId) {
        return res.json({
          answer: "Please log in first so I can check your orders.",
        });
      }

      const orders = await Order.find({ userID: userId }).lean();
      if (!orders || orders.length === 0) {
        return res.json({ answer: "You have no orders." });
      }

      let matched = [];

      for (const o of orders) {
        for (const item of o.items || []) {
          const name = (item.productName || "").toLowerCase();

          if (
            q.includes(name) ||
            name.includes(q) ||
            q.split(" ").some((w) => name.includes(w))
          ) {
            matched.push({
              product: item.productName,
              status: o.orderStatus,
              tracking: o.trackingUrl,
              date: o.orderDate,
            });
          }
        }
      }

      if (matched.length > 0) {
        let text = "Your order details:\n\n";
        matched.forEach((m, i) => {
          text += `#${i + 1}\nProduct: ${m.product}\nStatus: ${m.status}\n`;
          if (m.tracking) text += `Tracking: ${m.tracking}\n`;
          if (m.date) text += `Date: ${m.date}\n`;
          text += "\n";
        });
        return res.json({ answer: text });
      }

      return res.json({
        answer:
          "I couldn't match any product name in your orders. Try:\n• Order details for Samsung S25(5g)",
      });
    }

    // ------------- Greetings ----------------
    if (["hi", "hii", "hello", "hey"].some((w) => q.includes(w))) {
      return res.json({ answer: "Hello! I am NexBuyBot. How can I help you?" });
    }

    if (q.includes("how are you")) {
      return res.json({ answer: "I am good! How can I help you today?" });
    }

    if (q.includes("nexbuy") || q.includes("about")) {
      return res.json({
        answer:
          "NexBuy is your smart shopping platform , fast, secure, and user-friendly!",
      });
    }

    // ------------- PRODUCT SEARCH BY NAME -------------
    const product = await Product.findOne({
      name: { $regex: q, $options: "i" },
    });

    if (product) {
      const qty = product.quantity || 0;
      return res.json({
        answer: `${product.name}\nAvailability: ${
          qty > 0 ? `In Stock (${qty})` : "Out of Stock"
        }\nPrice: $${product.price}\n\n${product.description}`,
      });
    }

    return res.json({
      answer:
        "Product not found. Try asking:\n• Is Samsung S25 ",
    });
  })
);

// ------------------ IMAGE SEARCH ------------------
router.post(
  "/image-search",
  upload.single("image"),
  asyncHandler(async (req, res) => {
    if (!req.file) {
      return res.json({ answer: "Please upload an image." });
    }

    try {
      const uploaded = await Jimp.read(
        path.join(__dirname, "../uploads/bot", req.file.filename)
      );

      const products = await Product.find().lean();
      let matchedProduct = null;

      for (const p of products) {
        if (!p.images || p.images.length === 0) continue;

        const url = p.images[0].url; // FIXED: DB format uses url field
        if (!url) continue;

        let productImage;
        try {
          productImage = await Jimp.read(url); // Load from URL directly
        } catch {
          continue;
        }

        const img1 = uploaded.clone().resize(256, 256);
        const img2 = productImage.clone().resize(256, 256);

        const diff = Jimp.diff(img1, img2).percent;

        if (diff < 0.20) {
          matchedProduct = p;
          break;
        }
      }

      if (matchedProduct) {
        const qty = matchedProduct.quantity || 0;

        return res.json({
          answer: `Product found!\n\n${matchedProduct.name}\nAvailability: ${
            qty > 0 ? `In Stock (${qty})` : "Out of Stock"
          }\nPrice: $${matchedProduct.price}\n\n${matchedProduct.description}`,
        });
      }

      return res.json({
        answer: "Image does not match any product. Try uploading a clearer image.",
      });
    } catch (err) {
      console.error(err);
      return res.json({
        answer: "Error processing image. Please try again with a better one.",
      });
    }
  })
);

module.exports = router;
