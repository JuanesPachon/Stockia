import { Router } from 'express';
import { editUserController, loginController, registerController } from '../controllers/userControllers.js';
import { editUserValidations, loginValidations, userValidations } from '../middlewares/validateUser.js';
import errorsIsEmpty from '../middlewares/errorIsEmpty.js';
import verifyToken from '../middlewares/validateToken.js';

const router = Router();

router.post('/auth/register', userValidations, errorsIsEmpty, registerController);
router.post('/auth/login', loginValidations, errorsIsEmpty, loginController);
router.patch('/user', verifyToken, editUserValidations, errorsIsEmpty,editUserController);

export default router;
