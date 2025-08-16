import express from "express";
import "dotenv/config";
import cors from "cors";
import helmet from "helmet";
import path from "path";

const PORT = process.env.PORT || 3002;

const app = express();
app.use(cors());
app.use(helmet());
app.use(express.json());
app.disable("x-powered-by");
app.use(express.static(path.join(path.dirname(import.meta.filename), "../../public")));

app.listen(PORT, () => {
  console.log(`Server is running on port: ${PORT}`);
});