import express from "express";
import "dotenv/config";
import cors from "cors";
import helmet from "helmet";
import path from "path";
import cookieParser from "cookie-parser";
import "./config/mongoose.config.js";
import userRoutes from "./routes/userRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js";

const PORT = process.env.PORT || 3002;

const app = express();

const corsOptions = {
  origin: ['http://localhost:4200', 'http://127.0.0.1:4200'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
};

app.use(cors(corsOptions));
app.use(helmet());
app.use(express.json());
app.use(cookieParser());
app.disable("x-powered-by");
app.use(express.static(path.join(path.dirname(import.meta.filename), "../../public")));

app.use("/api/v1/", userRoutes);
app.use("/api/v1/", categoryRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port: ${PORT}`);
});