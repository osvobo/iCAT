<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3D Model Viewer</title>
    <style>
        body { margin: 0; overflow: hidden; }
        canvas { display: block; }
    </style>
</head>
<body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r152/three.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/three@0.152.0/examples/js/loaders/OBJLoader.js"></script>
    <script>
        // Set up the scene, camera, and renderer
        const scene = new THREE.Scene();
        const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
        const renderer = new THREE.WebGLRenderer();
        renderer.setSize(window.innerWidth, window.innerHeight);
        document.body.appendChild(renderer.domElement);

        // Add a light to the scene
        const light = new THREE.PointLight(0xffffff, 1, 100);
        light.position.set(10, 10, 10);
        scene.add(light);

        // Load the OBJ model
        const loader = new THREE.OBJLoader();
        loader.load(
            'https://github.com/osvobo/iCAT/blob/dev/support/iCat.obj', // Update with your file URL
            (object) => {
                scene.add(object);
                object.position.set(0, 0, 0); // Adjust position as needed
            },
            (xhr) => {
                console.log((xhr.loaded / xhr.total) * 100 + '% loaded');
            },
            (error) => {
                console.error('An error occurred:', error);
            }
        );

        // Set camera position
        camera.position.z = 5;

        // Animation loop
        const animate = function () {
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        };

        animate();
    </script>
</body>
</html>