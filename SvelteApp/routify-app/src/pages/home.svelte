<script>
    import { url } from '@roxi/routify';
 </script>
  
 <svelte:head>
    <title>Home Page</title>
 </svelte:head>
  
 <h1>Home</h1>
    <a href={$url('../example/explore')}>Add Owners</a>
  
 <style>
 a {
    display: block;
 }
 </style>