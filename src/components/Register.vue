<template>
    <div>
        <h4>Register</h4>
        <form>
            <label for="name">Name</label>
            <div>
                <input id="name" type="text" v-model="name" required autofocus>
            </div>
            <p v-if="check" class="error-message">
                ❗ This username is already in use
            </p>
            <label for="email" >E-Mail Address</label>
            <div>
                <input id="email" type="email" v-model="email" required>
            </div>

            <label for="password">Password</label>
            <div>
                <input id="password" type="password" v-model="password" required>
            </div>

            <label for="password-confirm">Confirm Password</label>
            <div>
                <input id="password-confirm" type="password" v-model="password_confirmation" required>
            </div>
            <div>
                <button type="submit" @click="handleSubmit">
                    Register
                </button>
            </div>
        </form>
    </div>
</template>
<script>

    export default {
        props : ["nextUrl"],
        data(){
            return {
                name : "",
                email : "",
                password : "",
                password_confirmation : "",
                check: false
            }
        },
        methods : {
            handleSubmit(e) {
                this.check = false;
                e.preventDefault();
                if (this.password === this.password_confirmation && this.password.length > 0)
                {
                    let url = "http://localhost:3000/api/register";
                    this.$http.post(url, {
                        name: this.name,
                        email: this.email,
                        password: this.password,
                    })
                        .then(response => {
                            if (response.data === "This username is already in use"){
                                this.check = true;
                            }
                            else {
                                localStorage.setItem('user',JSON.stringify(response.data.user));
                                localStorage.setItem('username', this.username);
                                localStorage.setItem('jwt',response.data.token);

                                if (localStorage.getItem('jwt') != null){
                                    this.$emit('loggedIn');
                                    if(this.$route.params.nextUrl != null){
                                        this.$router.push(this.$route.params.nextUrl)
                                    }
                                    else{
                                        this.$router.push('/')
                                    }
                                }
                            }
                        })
                        .catch(error => {
                            /* eslint-disable no-console */
                            console.error(error);
                        });
                } else {
                    this.password = "";
                    this.passwordConfirm = "";

                    return alert("Passwords do not match")
                }
            }
        }
    }
</script>
