<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Add a show</h1>
            <form @submit.prevent="addSeries">
                <label>Series name</label>
                <input type="text" v-model="series.name"/>
                <button>Add series</button>
                <p v-if="success" class="success-message">
                    ✅ Series successfully added
                </p>
                <p v-if="check" class="error-message">
                    ❗Series is already on your list
                </p>
                <p v-if="error" class="error-message">
                    ❗An error has occurred
                </p>
            </form>
        </div>
    </div>
</template>

<script>
    const axios = require('axios');
    export default {
        name: "app",
        data() {
            return {
                success: false,
                error: false,
                check: false,
                series: {
                    name: ''
                }
            }
        },
        methods: {
            addSeries() {
                const body = {
                    "showname": this.series.name
                };
                var uri = "http://localhost:3000/api/addseries/?showname=" + body.showname + "&username=" + "testuser";
                axios
                    .get(uri)
                    .then(response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        if (response.data === "on jo") {
                            this.check = true;
                            this.success = false;
                            this.error = false;

                        } else if (response.data === "ei ole") {
                            this.success = true;
                            this.check = false;
                            this.error = false;
                        } else {
                            this.error = true;
                            this.check = false;
                            this.success = false;
                        }
                    });
            },
        }
    }
</script>

<style scoped>
    .success-message {
        color: #32a95d;
    }
    .error-message {
        color: #d33c40;
    }
</style>