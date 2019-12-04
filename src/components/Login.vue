<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Login</h1>
            <form @submit.prevent="handleSubmit">
                <label>Username</label>
                <div><input type="text" v-model="username" required autofocus/></div>
                <label>Password</label>
                <div><input type="password" v-model="password" required/></div>
                <div><button>Login</button></div>
                <p v-if="error" class="error-message">
                    ❗Incorrect username or password
                </p>
            </form>
        </div>
    </div>
</template>

<script>
    export default {
        props: ["nextUrl"],
        data() {
            return {
                username: "",
                password: "",
                error: false,
            }
        },
        methods: {
            handleSubmit() {
                let url = "http://localhost:3000/api/login";
                this.$http.post(url, {
                    username: this.username,
                    password: this.password,
                })
                    .then(response => {
                        localStorage.setItem('user', JSON.stringify(response.data.user));
                        localStorage.setItem('username', this.username);
                        localStorage.setItem('jwt', response.data.token);
                        if (localStorage.getItem('jwt') != null) {
                            this.$emit('loggedIn');
                            this.error = false;
                            if (this.$route.params.nextUrl != null) {
                                this.$router.push(this.$route.params.nextUrl)
                            } else {
                                this.$router.push('/addseries')
                            }
                        }
                    })
                    .catch(error => {
                        // eslint-disable-next-line no-console
                        console.log(error);
                        this.error = true;
                        this.username = "";
                        this.password = "";
                    });

            },

        },
    }
</script>

<style scoped>
    .error-message {
        color: #d33c40;
    }
</style>
