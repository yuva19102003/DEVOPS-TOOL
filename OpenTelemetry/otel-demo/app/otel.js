// otel.js
const { NodeSDK } = require("@opentelemetry/sdk-node");
const { OTLPTraceExporter } =
  require("@opentelemetry/exporter-trace-otlp-http");

process.env.OTEL_SERVICE_NAME = "simple-demo";

const sdk = new NodeSDK({
  traceExporter: new OTLPTraceExporter({
    url: "http://localhost:4318/v1/traces",
  }),
});

sdk.start();
console.log("OTel started");
