import { Router } from "express";
import { 
    getNotesController, 
    getNoteController, 
    createNoteController, 
    updateNoteController, 
    deleteNoteController 
} from "../controllers/noteControllers.js";
import verifyToken from "../middlewares/validateToken.js";
import { noteValidations, editNoteValidations } from "../middlewares/validateNote.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.use(verifyToken);

router.get("/notes", getNotesController);
router.get("/notes/:id", getNoteController);
router.post("/notes", noteValidations, errorsIsEmpty, createNoteController);
router.patch("/notes/:id", editNoteValidations, errorsIsEmpty, updateNoteController);
router.delete("/notes/:id", deleteNoteController);

export default router;
