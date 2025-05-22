// Profile Photo Slideshow
document.addEventListener('DOMContentLoaded', function() {
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
    // Initial delay to make sure all slides are loaded
    setTimeout(function() {
      console.log("Starting slideshow with " + slides.length + " slides");
      // Set interval for auto rotation (2 seconds)
      setInterval(nextSlide, 2000);
    }, 500);
  }
}); 