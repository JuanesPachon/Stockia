export interface IRegisterResult {
    success: boolean;
    error?: 'duplicate' | 'server';
    message?: string;
}

export interface ILoginResult {
    success: boolean;
    error?: 'invalid_credentials' | 'server';
    message?: string;
    token?: string;
}

export interface ICreateAndEditResult {
    success: boolean;
    error?: 'not_found' | 'duplicate' | 'server';
    message?: string;
    data?: object;
}
