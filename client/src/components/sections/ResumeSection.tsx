import ScrollReveal from '../ui/ScrollReveal';
import { FileText, Download } from 'lucide-react';

export default function ResumeSection({ resumeUrl }: { resumeUrl?: string }) {
  return (
    <section id="resume" className="py-24 px-6">
      <div className="max-w-md mx-auto text-center">
        <ScrollReveal>
          <h2 className="font-playfair text-4xl font-bold text-white mb-8">Resume</h2>
          {resumeUrl ? (
            <a href={resumeUrl} target="_blank" rel="noreferrer"
              className="inline-flex items-center gap-3 px-8 py-4 bg-gold text-navy font-semibold rounded-xl hover:bg-gold-light transition-colors">
              <Download size={20} />Download Resume
            </a>
          ) : (
            <div className="flex flex-col items-center gap-4 text-gray-500">
              <FileText size={48} /><p>No resume uploaded yet.</p>
            </div>
          )}
        </ScrollReveal>
      </div>
    </section>
  );
}
