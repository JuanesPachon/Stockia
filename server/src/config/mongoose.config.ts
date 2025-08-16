import mongoose from "mongoose";
import "dotenv/config";

mongoose.connect(process.env.DB_CONNECTION_STRING || "")
    .then(() => console.log("Database connected successfully"))
    .catch((err) => console.error("Database connection err:", err));

export default mongoose;
