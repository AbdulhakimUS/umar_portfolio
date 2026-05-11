export interface Profile {
  id: string; name: string; tagline: string; about: string;
  photoUrl?: string; openToWork: boolean; resumeUrl?: string;
}
export interface ECActivity {
  id: string; imageUrl?: string; title: string; role: string;
  dateRange: string; description: string; category: string; order: number;
}
export interface School {
  id: string; name: string; grade: string; graduationYear: string; logoUrl?: string;
}
export interface Exam { id: string; name: string; score: string; date: string; status: string; }
export interface Certification {
  id: string; imageUrl?: string; name: string; issuer: string;
  date: string; description: string; link?: string;
}
export interface Project {
  id: string; imageUrl?: string; videoUrl?: string; title: string;
  description: string; impact?: string; tags: string[];
  githubUrl?: string; liveUrl?: string; order: number;
}
export interface HardSkill { id: string; name: string; category: string; level: number; }
export interface SoftSkill { id: string; name: string; icon: string; description: string; }
export interface Vision { id: string; text: string; anchorWord: string; }
export interface ContactLink { id: string; platform: string; icon: string; handle: string; url: string; order: number; }
