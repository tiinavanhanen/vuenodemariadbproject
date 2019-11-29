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
            <h2> Description</h2>
            <p>{{ info }}</p>
            <img id="poster"/>
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
                info: '',
                image: ''
            }
        },
        methods: {
            loadShow() {
                /* eslint-disable no-console */
                console.log("try to get info");
                var name = this.series_name;
                console.log(name);
                var uri = "http://localhost:3000/api/show/?series_name=" + name;
                axios
                    .get(uri)
                    .then(responce => {
                        this.show = responce.data;
                        console.log(JSON.stringify(this.show));
                        this.getDescription();
                    })
                    .catch(err => {
                        console.log(err);
                    });
            },

            getDescription() {
                var name = this.series_name;
                var uri = "https://api.themoviedb.org/3/search/tv?api_key=7d23aafdf005feaeec6939b430e5e4e4&language=en-US&query=" + name + "&page=1";
                axios
                    .get(uri)
                    .then(responce => {
                        console.log(responce);
                        var resultShow = responce.data.results[0];
                        this.info = resultShow.overview;
                        var poster = document.getElementById("poster");
                        poster.src="https://image.tmdb.org/t/p/w500" + resultShow.poster_path;
                        console.log(this.info);
                    })
                    .catch(err => {
                        console.log(err);
                    })
            }
        },
        mounted() {
            return this.loadShow();
        }
    }
</script>

<style scoped>

</style>