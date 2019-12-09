<template>
    <div>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark" >
        <h1 id="pageName">Serial Storage</h1>
    </nav>
    <div class="row justify-content-center">

        <div class="col-md-12" id="info">
            <h2 class="heading">Welcome to Serial Storage:
                a place where you can store and keep track of all the shows you are currently watching</h2>
        </div>
        <br>
            <div class="col-md-4">
                <p>Don't have an account yet?</p>
                <register></register>
            </div>
            <div class="col-md-4">
                <p>Already have an account?</p>
                <login></login>
            </div>
    </div>
    </div>
</template>
<script>
    import Register from "@/components/Register";
    import Login from "@/components/Login";
    export default {
        components: {Register, Login}
    }
</script>
<style scoped>
    #info {
        padding: 3em;
    }
    .heading  {
        text-align: center;
    }
    #pageName{
        color: white;
    }
</style>
