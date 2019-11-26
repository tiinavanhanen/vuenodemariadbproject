<template>
    <div class="row justify-content-center">
        <div class="col-md-8">
            <h1>Show details</h1>

            <table class="table table-striped">

                <thead>
                <tr>
                    <th>Name</th>
                    <th>Genre</th>
                    <th>Votes</th>
                    <th>Rating</th>
                </tr>
                </thead>
                <tbody>
                    <tr v-for="show in show" :key="show.series_name">
                        <td>{{ show.series_name }} </td>
                        <td>{{show.genre_name1}}, {{show.genre_name2}}, {{show.genre_name3}}</td>
                        <td>{{ show.votes }} </td>
                        <td>{{ show.rating }}</td>

                    </tr>

                </tbody>
            </table>

        </div>
    </div>
</template>

<script>
    const axios = require('axios');
    export default {
        name: "ShowComponent",

        props: {
            series_name: {
                type: String,
                required: true
            }
        },
        data() {
            return {
                show: [],

            }
        },
        methods: {
            loadShow() {

                /* eslint-disable no-console */
                console.log("try to get info");
                console.log("name" + this.series_name);
                var name = this.series_name;
                console.log(name);
                var uri = "http://localhost:3000/api/show/?series_name=" + name;
                axios
                    .get(uri)
                    .then(responce => {
                        this.isLoading = false;
                        /* eslint-disable no-console */
                        console.log("got a result");
                        console.log(responce);
                        this.show = responce.data;
                        console.log(this.show);
                        console.log(JSON.stringify(this.show));

                    })
                    .catch(err => {
                        //this.msg = err.message;
                        /* eslint-disable no-console */
                        console.log(err);
                        /* eslint-enable no-console */
                    });
            }
        },


        mounted() {
            return this.loadShow();
        }
    }
</script>

<style scoped>

</style>