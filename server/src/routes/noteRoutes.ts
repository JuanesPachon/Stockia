import { Router } from "express";
import { createNoteController } from "../controllers/noteControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { noteValidations } from "../middlewares/validateNote.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.post("/notes", noteValidations, errorsIsEmpty, createNoteController);

export default router;
