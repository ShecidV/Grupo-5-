import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators, AbstractControl, ValidationErrors } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-reset-password',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  templateUrl: './reset-password.component.html',
  styleUrls: ['./reset-password.component.scss']
})
export class ResetPasswordComponent implements OnInit {
  resetForm: FormGroup;
  token = '';
  showPassword = false;
  showConfirmPassword = false;
  isLoading = false;
  successMessage = '';
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private authService: AuthService
  ) {
    this.resetForm = this.fb.group(
      {
        new_password: ['', [Validators.required, this.passwordStrengthValidator]],
        confirm_password: ['', [Validators.required]]
      },
      { validators: this.passwordsMatchValidator }
    );
  }

  ngOnInit(): void {
    this.token = this.route.snapshot.queryParams['token'] || '';
    if (!this.token) {
      this.errorMessage = 'Token de recuperación ausente o no válido.';
    }
  }

  // Custom password strength validator
  passwordStrengthValidator(control: AbstractControl): ValidationErrors | null {
    const val = control.value || '';
    const hasMinLength = val.length >= 8;
    const hasUpper = /[A-Z]/.test(val);
    const hasLower = /[a-z]/.test(val);
    const hasNumber = /[0-9]/.test(val);
    const hasSpecial = /[!@#$%^&*()_\-+=\.,]/.test(val);

    if (hasMinLength && hasUpper && hasLower && hasNumber && hasSpecial) {
      return null;
    }
    return { passwordStrength: true };
  }

  // Password matching validator
  passwordsMatchValidator(control: AbstractControl): ValidationErrors | null {
    const newPass = control.get('new_password')?.value;
    const confirmPass = control.get('confirm_password')?.value;
    if (newPass && confirmPass && newPass !== confirmPass) {
      return { passwordMismatch: true };
    }
    return null;
  }

  // Checkers for password requirements indicators
  get hasMinLength(): boolean {
    return (this.resetForm.get('new_password')?.value || '').length >= 8;
  }

  get hasUpper(): boolean {
    return /[A-Z]/.test(this.resetForm.get('new_password')?.value || '');
  }

  get hasLower(): boolean {
    return /[a-z]/.test(this.resetForm.get('new_password')?.value || '');
  }

  get hasNumber(): boolean {
    return /[0-9]/.test(this.resetForm.get('new_password')?.value || '');
  }

  get hasSpecial(): boolean {
    return /[!@#$%^&*()_\-+=\.,]/.test(this.resetForm.get('new_password')?.value || '');
  }

  togglePasswordVisibility(): void {
    this.showPassword = !this.showPassword;
  }

  toggleConfirmPasswordVisibility(): void {
    this.showConfirmPassword = !this.showConfirmPassword;
  }

  onSubmit(): void {
    if (!this.token) {
      this.errorMessage = 'El token de recuperación no es válido.';
      return;
    }

    if (this.resetForm.invalid) {
      this.resetForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.successMessage = '';

    const payload = {
      token: this.token,
      new_password: this.resetForm.value.new_password,
      confirm_password: this.resetForm.value.confirm_password
    };

    this.authService.resetPassword(payload).subscribe({
      next: (res) => {
        this.isLoading = false;
        this.successMessage = res.message || 'Contraseña restablecida correctamente.';
        setTimeout(() => {
          this.router.navigate(['/login']);
        }, 3000);
      },
      error: (err) => {
        this.isLoading = false;
        if (err.error?.detail) {
          this.errorMessage = typeof err.error.detail === 'string'
            ? err.error.detail
            : 'Error al restablecer la contraseña.';
        } else {
          this.errorMessage = 'No se pudo restablecer la contraseña. Intente más tarde.';
        }
      }
    });
  }
}
