const amqp = require("amqplib");

const QUEUE = "order_queue";

async function consume() {
  const connection = await amqp.connect("amqp://localhost");
  const channel = await connection.createChannel();

  await channel.assertQueue(QUEUE, { durable: true });

  // Important for load control
  channel.prefetch(1);

  console.log("👂 Waiting for messages...");

  channel.consume(QUEUE, (msg) => {
    if (!msg) return;

    const data = JSON.parse(msg.content.toString());
    console.log("📥 Received:", data);

    // simulate processing
    setTimeout(() => {
      channel.ack(msg);
      console.log("✅ Processed:", data.type);
    }, 1000);
  });
}

consume().catch(console.error);
