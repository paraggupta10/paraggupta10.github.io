// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  // Photo Gallery
  const galleryThumbs = document.querySelectorAll('.gallery-thumb');
  const mainPhoto = document.getElementById('main-photo');
  
  galleryThumbs.forEach(thumb => {
    thumb.addEventListener('click', function() {
      // Update active thumbnail
      galleryThumbs.forEach(t => t.classList.remove('active'));
      this.classList.add('active');
      
      // Update main photo
      const imgSrc = this.getAttribute('data-img');
      mainPhoto.src = imgSrc;
      
      // Add a fade effect
      mainPhoto.style.opacity = '0';
      setTimeout(() => {
        mainPhoto.style.opacity = '1';
      }, 200);
    });
  });
  
  // Auto rotate photos every 5 seconds
  let currentPhotoIndex = 0;
  
  function rotatePhotos() {
    currentPhotoIndex = (currentPhotoIndex + 1) % galleryThumbs.length;
    galleryThumbs[currentPhotoIndex].click();
  }
  
  // Start photo rotation if gallery exists
  if (galleryThumbs.length > 0) {
    const photoInterval = setInterval(rotatePhotos, 5000);
    
    // Pause rotation when hovering over gallery
    const gallery = document.querySelector('.hero-gallery');
    if (gallery) {
      gallery.addEventListener('mouseenter', () => {
        clearInterval(photoInterval);
      });
      
      gallery.addEventListener('mouseleave', () => {
        clearInterval(photoInterval);
        photoInterval = setInterval(rotatePhotos, 5000);
      });
    }
  }
  
  // Profile Photo Showcase
  const profilePhotos = document.querySelectorAll('.profile-photos .profile-photo');
  const mainPhotoProfile = document.querySelector('.main-photo');
  
  if (profilePhotos.length > 0 && mainPhotoProfile) {
    profilePhotos.forEach(photo => {
      photo.addEventListener('click', function() {
        // Update active photo
        profilePhotos.forEach(p => p.classList.remove('active'));
        this.classList.add('active');
        
        // Update main photo with animation
        const imgSrc = this.getAttribute('data-img');
        
        // Create fade out effect
        mainPhotoProfile.style.opacity = '0';
        mainPhotoProfile.style.transform = 'scale(0.95) translateZ(-10px)';
        
        setTimeout(() => {
          mainPhotoProfile.style.backgroundImage = `url('${imgSrc}')`;
          
          // Create fade in effect
          mainPhotoProfile.style.opacity = '1';
          mainPhotoProfile.style.transform = 'scale(1) translateZ(0)';
        }, 300);
      });
    });
    
    // Add subtle parallax effect on mouse move
    const showcase = document.querySelector('.profile-showcase');
    
    if (showcase) {
      showcase.addEventListener('mousemove', function(e) {
        // Get mouse position relative to showcase
        const rect = showcase.getBoundingClientRect();
        const mouseX = e.clientX - rect.left;
        const mouseY = e.clientY - rect.top;
        
        // Calculate rotation based on mouse position
        const rotateX = (mouseY / rect.height - 0.5) * 10;
        const rotateY = (mouseX / rect.width - 0.5) * -10;
        
        // Apply rotation to photos
        profilePhotos.forEach(photo => {
          const intensity = 0.5;
          photo.style.transform = `${photo.style.transform.split('rotate')[0]} rotate${photo.style.transform.split('rotate')[1]} perspective(1000px) rotateX(${rotateX * intensity}deg) rotateY(${rotateY * intensity}deg)`;
        });
        
        mainPhotoProfile.style.transform = `perspective(1000px) rotateX(${rotateX * 0.3}deg) rotateY(${rotateY * 0.3}deg)`;
      });
      
      // Reset on mouse leave
      showcase.addEventListener('mouseleave', function() {
        profilePhotos.forEach(photo => {
          // Reset to original rotation by preserving only the original rotation part
          const originalTransform = photo.className.includes('photo1') ? 'rotate(5deg)' : 
                                   photo.className.includes('photo2') ? 'rotate(-8deg)' : 'rotate(10deg)';
          
          if (photo.className.includes('photo1')) {
            photo.style.transform = 'rotate(5deg)';
          } else if (photo.className.includes('photo2')) {
            photo.style.transform = 'rotate(-8deg)';
          } else if (photo.className.includes('photo3')) {
            photo.style.transform = 'rotate(10deg)';
          }
        });
        
        mainPhotoProfile.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg)';
      });
    }
  }
  
  // Navbar scroll effect
  const navbar = document.querySelector('.navbar');
  const menuBtn = document.querySelector('.menu-btn');
  const nav = document.querySelector('nav');
  
  window.addEventListener('scroll', function() {
    if (window.scrollY > 100) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  });
  
  // Mobile menu toggle
  menuBtn.addEventListener('click', function() {
    menuBtn.classList.toggle('active');
    nav.classList.toggle('active');
  });
  
  // Close mobile menu when clicking a nav link
  document.querySelectorAll('nav ul li a').forEach(link => {
    link.addEventListener('click', function() {
      menuBtn.classList.remove('active');
      nav.classList.remove('active');
    });
  });
  
  // Smooth scrolling for navigation links
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      e.preventDefault();
      
      const targetId = this.getAttribute('href');
      const targetElement = document.querySelector(targetId);
      
      if (targetElement) {
        window.scrollTo({
          top: targetElement.offsetTop - 70,
          behavior: 'smooth'
        });
      }
    });
  });
  
  // Active link highlighting based on scroll position
  const sections = document.querySelectorAll('section');
  const navLinks = document.querySelectorAll('nav ul li a');
  
  window.addEventListener('scroll', function() {
    let current = '';
    
    sections.forEach(section => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.clientHeight;
      
      if (window.scrollY >= sectionTop - 200) {
        current = section.getAttribute('id');
      }
    });
    
    navLinks.forEach(link => {
      link.classList.remove('active');
      if (link.getAttribute('href') === `#${current}`) {
        link.classList.add('active');
      }
    });
  });
  
  // Work experience tabs
  const workTabBtns = document.querySelectorAll('.work-tab-btn');
  const workTabContents = document.querySelectorAll('.work-tab-content');
  let currentTabIndex = 0;
  
  function updateActiveTab(index) {
    // Remove active class from all buttons and contents
    workTabBtns.forEach(btn => btn.classList.remove('active'));
    workTabContents.forEach(content => content.classList.remove('active'));
    
    // Add active class to current button and content
    workTabBtns[index].classList.add('active');
    workTabContents[index].classList.add('active');
    
    // Update current tab index
    currentTabIndex = index;
  }
  
  workTabBtns.forEach((btn, index) => {
    btn.addEventListener('click', function() {
      updateActiveTab(index);
    });
  });
  
  // Experience tab arrow navigation
  const prevBtn = document.querySelector('.work-exp-only .exp-prev');
  const nextBtn = document.querySelector('.work-exp-only .exp-next');
  
  if (prevBtn && nextBtn) {
    prevBtn.addEventListener('click', function() {
      let newIndex = currentTabIndex - 1;
      if (newIndex < 0) {
        newIndex = workTabBtns.length - 1; // Loop to the last tab
      }
      updateActiveTab(newIndex);
    });
    
    nextBtn.addEventListener('click', function() {
      let newIndex = currentTabIndex + 1;
      if (newIndex >= workTabBtns.length) {
        newIndex = 0; // Loop to the first tab
      }
      updateActiveTab(newIndex);
    });
  }
  
  // Project Modal Functionality
  const projectModal = document.querySelector('.project-modal');
  const modalContent = document.querySelector('.project-modal-content');
  const modalClose = document.querySelector('.modal-close');
  const modalTitle = document.querySelector('.modal-title');
  const modalBody = document.querySelector('.modal-body');
  const detailsBtns = document.querySelectorAll('.project-details-btn');
  const projectDetails = document.getElementById('project-details');
  
  // Open modal when clicking on project details button
  detailsBtns.forEach(btn => {
    btn.addEventListener('click', function() {
      const projectCard = this.closest('.project-card');
      const projectId = projectCard.getAttribute('data-id');
      const projectTitle = projectCard.querySelector('h3').textContent;
      
      // Find the corresponding project details
      const projectDetail = projectDetails.querySelector(`[data-project="${projectId}"]`);
      
      if (projectDetail) {
        modalTitle.textContent = projectTitle;
        modalBody.innerHTML = projectDetail.innerHTML;
        
        // Show modal
        projectModal.classList.add('show');
        setTimeout(() => {
          modalContent.style.opacity = '1';
          modalContent.style.transform = 'translateY(0)';
        }, 10);
        
        // Prevent body scrolling
        document.body.style.overflow = 'hidden';
      }
    });
  });
  
  // Close modal on clicking close button
  modalClose.addEventListener('click', closeModal);
  
  // Close modal when clicking outside of modal content
  projectModal.addEventListener('click', function(e) {
    if (e.target === projectModal) {
      closeModal();
    }
  });
  
  // Close modal when pressing ESC key
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && projectModal.classList.contains('show')) {
      closeModal();
    }
  });
  
  function closeModal() {
    modalContent.style.opacity = '0';
    modalContent.style.transform = 'translateY(50px)';
    
    setTimeout(() => {
      projectModal.classList.remove('show');
      document.body.style.overflow = 'auto';
    }, 300);
  }
  
  // Typed.js effect
  const typedTextElement = document.querySelector('.typed-text');
  if (typedTextElement) {
    const textContent = typedTextElement.textContent;
    typedTextElement.textContent = '';
    
    let idx = 0;
    const typingSpeed = 100;
    
    function typeText() {
      if (idx < textContent.length) {
        typedTextElement.textContent += textContent.charAt(idx);
        idx++;
        setTimeout(typeText, typingSpeed);
      }
    }
    
    setTimeout(typeText, 500);
  }
  
  // Project filtering
  const filterButtons = document.querySelectorAll('.filter-btn');
  const projectCards = document.querySelectorAll('.project-card');
  
  filterButtons.forEach(button => {
    button.addEventListener('click', function() {
      // Remove active class from all buttons
      filterButtons.forEach(btn => btn.classList.remove('active'));
      
      // Add active class to clicked button
      this.classList.add('active');
      
      const filter = this.getAttribute('data-filter');
      
      projectCards.forEach(card => {
        const categories = card.getAttribute('data-category').split(' ');
        if (filter === 'all' || categories.includes(filter)) {
          card.style.display = 'block';
          setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
          }, 100);
        } else {
          card.style.opacity = '0';
          card.style.transform = 'translateY(20px)';
          setTimeout(() => {
            card.style.display = 'none';
          }, 300);
        }
      });
    });
  });
  
  // Animate elements on scroll
  const animateElements = document.querySelectorAll('.work-tab-content, .skill-group, .project-card, .achievement-card, .contact-card');
  
  // Initial state - hide all elements to be animated
  animateElements.forEach(element => {
    element.style.opacity = '0';
    element.style.transform = 'translateY(20px)';
  });
  
  function checkScroll() {
    animateElements.forEach(element => {
      const elementPosition = element.getBoundingClientRect().top;
      const screenPosition = window.innerHeight;
      
      if (elementPosition < screenPosition - 100) {
        element.style.opacity = '1';
        element.style.transform = 'translateY(0)';
        element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
      }
    });
  }
  
  // Check on initial load
  setTimeout(checkScroll, 300);
  
  // Check on scroll
  window.addEventListener('scroll', checkScroll);
  
  // Contact form submission
  const contactForm = document.getElementById('contactForm');
  
  if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const nameInput = document.getElementById('name');
      const emailInput = document.getElementById('email');
      const subjectInput = document.getElementById('subject');
      const messageInput = document.getElementById('message');
      
      // Form validation logic would go here
      
      // Show success message (in a real scenario, you'd send the form data to a server)
      const formElements = contactForm.elements;
      for (let i = 0; i < formElements.length; i++) {
        formElements[i].disabled = true;
      }
      
      const successMessage = document.createElement('div');
      successMessage.classList.add('success-message');
      successMessage.textContent = 'Thank you for your message! I will get back to you soon.';
      successMessage.style.color = '#00897b';
      successMessage.style.marginTop = '20px';
      successMessage.style.padding = '10px';
      successMessage.style.border = '1px solid #00897b';
      successMessage.style.borderRadius = '4px';
      
      contactForm.appendChild(successMessage);
      
      // Reset form after 3 seconds
      setTimeout(() => {
        contactForm.reset();
        for (let i = 0; i < formElements.length; i++) {
          formElements[i].disabled = false;
        }
        contactForm.removeChild(successMessage);
      }, 3000);
    });
  }
  
  // Initialize animated skill progress bars
  function initSkillBars() {
    const skillItems = document.querySelectorAll('.skill-progress-item');
    
    skillItems.forEach(item => {
      const percentage = item.getAttribute('data-percentage');
      const progressFill = item.querySelector('.skill-progress-fill');
      
      // Set width to 0 initially
      if (progressFill) {
        progressFill.style.width = '0%';
      }
    });
  }
  
  function animateSkillBars() {
    const skillItems = document.querySelectorAll('.skill-progress-item');
    
    skillItems.forEach(item => {
      const percentage = item.getAttribute('data-percentage');
      const progressFill = item.querySelector('.skill-progress-fill');
      const elementTop = item.getBoundingClientRect().top;
      const elementVisible = 150;
      
      if (elementTop < window.innerHeight - elementVisible && progressFill) {
        setTimeout(() => {
          progressFill.style.width = percentage + '%';
        }, 200);
      }
    });
  }
  
  // Initialize skill bars
  initSkillBars();
  
  // Check position and animate on scroll
  window.addEventListener('scroll', animateSkillBars);
  
  // Trigger once on page load
  setTimeout(animateSkillBars, 500);
  
  // Simple auto-rotating slideshow
  const slides = document.querySelectorAll('.slide');
  let currentSlide = 0;
  
  function nextSlide() {
    // Remove active class from current slide
    slides[currentSlide].classList.remove('active');
    
    // Move to next slide, loop back to first if at the end
    currentSlide = (currentSlide + 1) % slides.length;
    
    // Add active class to new current slide
    slides[currentSlide].classList.add('active');
  }
  
  // Start slideshow if slides exist
  if (slides.length > 0) {
    // Set interval for auto rotation (2 seconds)
    setInterval(nextSlide, 2000);
  }
}); 