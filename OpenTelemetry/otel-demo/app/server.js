const express = require("express");
const { trace } = require("@opentelemetry/api");

const app = express();
const tracer = trace.getTracer("demo-tracer");

/**
 * STEP 1: Client calls this route
 */
app.get("/order", (req, res) => {

  // STEP 2: Business logic span
  tracer.startActiveSpan("validate-order", span1 => {

    fakeValidate();

    // STEP 3: Nested business logic span
    tracer.startActiveSpan("charge-payment", span2 => {
      fakePayment();
      span2.end();
    });

    span1.end();
  });

  res.send("order completed");
});

function fakeValidate() {
  // pretend work
}

function fakePayment() {
  // pretend work
}


app.get("/cancel", (req, res) => {

  // STEP 2: Business logic span
  tracer.startActiveSpan("validate-order-cancel", span1 => {

    fakeValidatecancel();

    // STEP 3: Nested business logic span
    tracer.startActiveSpan("charge-payment-cancel", span2 => {
      fakePaymentcancel();
      span2.end();
    });

    span1.end();
  });

  res.send("order completed");
});

function fakeValidatecancel() {
  // pretend work
}

function fakePaymentcancel() {
  // pretend work
}


app.listen(3000, () => {
  console.log("Server running on http://localhost:3000");
});
