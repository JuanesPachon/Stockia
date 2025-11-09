import express from "express";
import "dotenv/config";
import cors from "cors";
import helmet from "helmet";
import path from "path";
import cookieParser from "cookie-parser";
import "./config/mongoose.config.js";
import userRoutes from "./routes/userRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js";
import productRoutes from "./routes/productRoutes.js";
import providerRoutes from "./routes/providerRoutes.js";
import noteRoutes from "./routes/noteRoutes.js";
import expenseRoutes from "./routes/expenseRoutes.js";
import saleRoutes from "./routes/saleRoutes.js";

const PORT = process.env.PORT || 3002;

const app = express();

const corsOptions = {
  origin: function (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) {
    if (!origin) return callback(null, true);
    
    if (origin.includes('localhost') || origin.includes('127.0.0.1')) {
      return callback(null, true);
    }
    
    if (origin.includes('netlify.app')) {
      return callback(null, true);
    }
    
    callback(new Error('Not allowed by CORS'));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
};

app.use(cors(corsOptions));
app.use(helmet());
app.use(express.json());
app.use(cookieParser());
app.disable("x-powered-by");
app.use(express.static(path.join(path.dirname(import.meta.filename), './public')));

app.use("/api/v1/", userRoutes);
app.use("/api/v1/", categoryRoutes);
app.use("/api/v1/", productRoutes);
app.use("/api/v1/", providerRoutes);
app.use("/api/v1/", noteRoutes);
app.use("/api/v1/", expenseRoutes);
app.use("/api/v1/", saleRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port: ${PORT}`);
});