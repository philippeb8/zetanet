function showSlides(slides, n) 
{
    n = ((n % slides.length) + slides.length) % slides.length;

    for (var i = 0; i < slides.length; ++ i) 
        slides[i].style.display = "none"; 
    
    slides[n].style.display = "block";
    
    return n;
}
