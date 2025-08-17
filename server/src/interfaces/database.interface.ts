export interface IRegisterResult {
    success: boolean;
    error?: 'duplicate' | 'server' | 'validation';
    message?: string;
}

export interface ILoginResult {
    success: boolean;
    error?: 'invalid_credentials' | 'server';
    message?: string;
    token?: string;
}