import { Router } from "express";
import { loginController, logoutController, registerController } from "../controllers/userControllers.js";
import { userValidations } from "../middlewares/validateAuth.js";
import errorsIsEmpty from "../middlewares/errorIsEmpty.js";

const router = Router();

router.post("/auth/register", userValidations, errorsIsEmpty, registerController);
router.post("/auth/login", loginController);
router.post("/auth/logout", logoutController);

export default router;