const amqp = require("amqplib");
const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const EXCHANGE = "order_exchange";

// Message map
const messages = {
  "1": {
    routingKey: "order.created",
    payload: {
      type: "ORDER_CREATED",
      orderId: 101,
      item: "Laptop",
      price: 90000
    }
  },
  "2": {
    routingKey: "order.cancelled",
    payload: {
      type: "ORDER_CANCELLED",
      orderId: 101,
      reason: "User cancelled"
    }
  },
  "3": {
    routingKey: "order.shipped",
    payload: {
      type: "ORDER_SHIPPED",
      orderId: 101,
      courier: "BlueDart"
    }
  }
};

async function produce(choice) {
  const msg = messages[choice];
  if (!msg) {
    console.log("❌ Invalid choice");
    process.exit(1);
  }

  const connection = await amqp.connect("amqp://localhost");
  const channel = await connection.createChannel();

  await channel.assertExchange(EXCHANGE, "direct", { durable: true });

  channel.publish(
    EXCHANGE,
    msg.routingKey,
    Buffer.from(JSON.stringify(msg.payload)),
    { persistent: true }
  );

  console.log("📤 Sent:", msg.payload);

  setTimeout(() => {
    connection.close();
    process.exit(0);
  }, 500);
}

rl.question(
  `
Select message to send:
1 → Order Created
2 → Order Cancelled
3 → Order Shipped

Enter choice (1/2/3): `,
  (answer) => {
    produce(answer.trim()).catch(console.error);
    rl.close();
  }
);
