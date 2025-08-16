import { Router } from "express";
import { loginController, logoutController, registerController } from "../controllers/userControllers.js";

const router = Router();

router.post("/auth/register", registerController);
router.post("/auth/login", loginController);
router.post("/auth/logout", logoutController);

export default router;