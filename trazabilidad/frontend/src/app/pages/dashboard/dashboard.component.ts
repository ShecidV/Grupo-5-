import { Component, OnInit, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { AuthService } from '../../core/services/auth.service';
import { User } from '../../core/models/auth.models';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  currentUser = signal<User | null>(null);
  isLoading = signal<boolean>(true);

  constructor(public authService: AuthService) {}

  ngOnInit(): void {
    // Read user from AuthService signal or fetch from /me
    const cachedUser = this.authService.currentUser();
    if (cachedUser) {
      this.currentUser.set(cachedUser);
      this.isLoading.set(false);
    } else {
      this.authService.getMe().subscribe({
        next: (user) => {
          this.currentUser.set(user);
          this.isLoading.set(false);
        },
        error: () => {
          this.isLoading.set(false);
        }
      });
    }
  }

  onLogout(): void {
    this.authService.logout();
  }
}
