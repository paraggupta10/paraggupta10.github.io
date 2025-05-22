// Resume link handler - tries multiple possible paths to the resume file
document.addEventListener('DOMContentLoaded', function() {
  // Select any link that contains "Resume" as text in the nav
  const resumeLinks = document.querySelectorAll('nav a');
  
  for (const link of resumeLinks) {
    if (link.textContent.trim() === 'Resume') {
      link.addEventListener('click', function(e) {
        // List of possible paths to try
        const paths = [
          '../Parag_Gupta_Resume.pdf',
          './assets/resume/Parag_Gupta_Resume.pdf',
          '/Parag_Gupta_Resume.pdf',
          link.getAttribute('href') // Original path as fallback
        ];
        
        // Function to check if a file exists
        const fileExists = async (url) => {
          try {
            const response = await fetch(url, { method: 'HEAD' });
            return response.ok;
          } catch (error) {
            return false;
          }
        };
        
        // Try each path
        const tryPaths = async () => {
          for (const path of paths) {
            // Skip if path is null or undefined
            if (!path) continue;
            
            if (await fileExists(path)) {
              window.open(path, '_blank');
              return true;
            }
          }
          return false;
        };
        
        // Prevent default link behavior and try our paths
        e.preventDefault();
        tryPaths().then(success => {
          if (!success) {
            // If all paths fail, try the default path anyway
            window.open(link.href, '_blank');
            console.log('No working path found, using default: ' + link.href);
          }
        });
      });
      
      break; // Found the Resume link, no need to continue
    }
  }
});

// Resume handler - opens the resume PDF in a new tab
function openResume() {
  // Try to open the resume using the relative path from the workspace root
  window.open('../Parag_Gupta_Resume.pdf', '_blank');
}

// Backup handler if the onclick attribute isn't working
document.addEventListener('DOMContentLoaded', function() {
  const resumeLink = document.querySelector('.resume-link');
  if (resumeLink) {
    resumeLink.addEventListener('click', function(e) {
      e.preventDefault();
      openResume();
    });
  }
}); 