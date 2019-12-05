<template>
    <div class="row justify-content-center">
        <div class="col-md-12">
            <h2>Welcome to Serial Storage:
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
</template>
<script>
    import Register from "@/components/Register";
    import Login from "@/components/Login";
    export default {
        components: {Register, Login}
    }
</script>
