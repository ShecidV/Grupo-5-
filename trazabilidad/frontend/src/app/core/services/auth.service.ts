import { Injectable, signal, computed } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, tap, catchError, throwError, of } from 'rxjs';
import {
  User,
  LoginRequest,
  TokenResponse,
  ForgotPasswordRequest,
  ResetPasswordRequest,
  MessageResponse
} from '../models/auth.models';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://localhost:8000/api/v1/auth';

  // Signals for reactive state management
  currentUser = signal<User | null>(null);
  token = signal<string | null>(localStorage.getItem('access_token'));
  isAuthenticated = computed(() => !!this.token());

  constructor(private http: HttpClient, private router: Router) {
    if (this.token()) {
      this.getMe().subscribe({
        error: () => this.clearSession()
      });
    }
  }

  getToken(): string | null {
    return this.token();
  }

  login(credentials: LoginRequest): Observable<TokenResponse> {
    return this.http.post<TokenResponse>(`${this.apiUrl}/login`, credentials, {
      withCredentials: true
    }).pipe(
      tap(res => {
        localStorage.setItem('access_token', res.access_token);
        this.token.set(res.access_token);
        this.currentUser.set(res.user);
      })
    );
  }

  getMe(): Observable<User> {
    return this.http.get<User>(`${this.apiUrl}/me`).pipe(
      tap(user => this.currentUser.set(user)),
      catchError(err => {
        this.clearSession();
        return throwError(() => err);
      })
    );
  }

  refreshToken(): Observable<TokenResponse> {
    return this.http.post<TokenResponse>(`${this.apiUrl}/refresh`, {}, {
      withCredentials: true
    }).pipe(
      tap(res => {
        localStorage.setItem('access_token', res.access_token);
        this.token.set(res.access_token);
        this.currentUser.set(res.user);
      })
    );
  }

  logout(): void {
    this.http.post<MessageResponse>(`${this.apiUrl}/logout`, {}, {
      withCredentials: true
    }).subscribe({
      next: () => this.clearSessionAndRedirect(),
      error: () => this.clearSessionAndRedirect()
    });
  }

  forgotPassword(data: ForgotPasswordRequest): Observable<MessageResponse> {
    return this.http.post<MessageResponse>(`${this.apiUrl}/forgot-password`, data);
  }

  resetPassword(data: ResetPasswordRequest): Observable<MessageResponse> {
    return this.http.post<MessageResponse>(`${this.apiUrl}/reset-password`, data);
  }

  private clearSession(): void {
    localStorage.removeItem('access_token');
    this.token.set(null);
    this.currentUser.set(null);
  }

  private clearSessionAndRedirect(): void {
    this.clearSession();
    this.router.navigate(['/login']);
  }
}
