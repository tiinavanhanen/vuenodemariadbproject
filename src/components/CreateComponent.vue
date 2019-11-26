<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Add a show</h1>
            <form @submit.prevent="addSeries">
                <label>Show name</label>
                <input type="text" v-model="show.name"/>
                <button>Add show</button>
                <p v-if="success" class="success-message">
                    ✅ Series successfully added
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
                show: {
                    name: ''
                }
            }
        },
        methods: {
            addSeries() {
                const body = {
                    "showname": this.show.name
                };
                var uri = "http://localhost:8080/api/addseries/?showname=" + body.showname + "&username=" + "testuser";
                axios
                    .get(uri)
                    .then(response => {
                        this.success = true;
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.success = false;
                    });
            },
        }
    }
</script>

<style scoped>
    .success-message {
        color: #32a95d;
    }
</style>