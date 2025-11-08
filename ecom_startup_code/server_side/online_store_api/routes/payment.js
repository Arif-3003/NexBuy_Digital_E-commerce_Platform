const express = require('express');
const asyncHandler = require('express-async-handler');
const Stripe = require('stripe');
const dotenv = require('dotenv');

dotenv.config();

const router = express.Router();
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

router.post('/stripe', asyncHandler(async (req, res) => {
  try {
    console.log('stripe');
    const { email, name, address, amount, currency, description } = req.body;

    const customer = await stripe.customers.create({ email, name, address });
    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer: customer.id },
      { apiVersion: '2023-10-16' }
    );
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      customer: customer.id,
      description,
      automatic_payment_methods: { enabled: true },
    });

    res.json({
      paymentIntent: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer: customer.id,
      publishableKey: process.env.STRIPE_PUBLIC_KEY,
    });
  } catch (error) {
    console.log(error);
    return res.json({ error: true, message: error.message, data: null });
  }
}));

router.post('/razorpay', asyncHandler(async (req, res) => {
  try {
    console.log('razorpay');
    const razorpayKey = process.env.RAZORPAY_KEY_TEST;
    res.json({ key: razorpayKey });
  } catch (error) {
    console.log(error.message);
    res.status(500).json({ error: true, message: error.message, data: null });
  }
}));

module.exports = router;
