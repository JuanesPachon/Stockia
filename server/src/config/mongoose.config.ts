import mongoose from "mongoose";
import "dotenv/config";

mongoose.connect(process.env.DB_CONNECTION_STRING || "")
    .then(() => console.log("Database connected successfully"))
    .catch((err) => console.error("Database connection err:", err));

mongoose.connection.on('error', (err) => {
  console.error('Database error:', err);
});

export default mongoose;
