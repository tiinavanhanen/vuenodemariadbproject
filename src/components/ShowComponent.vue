<template>
    <div class="row justify-content-center">
        <menucomponent></menucomponent>
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
                        <td>{{show.genre_name1}} {{show.genre_name2}} {{show.genre_name3}} {{show.genre_name4}} {{ show.genre_name5}}</td>
                        <td>{{ show.votes }} </td>
                        <td>{{ show.rating  | numFormat('0.00') }}</td>
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
    //import the menu
    import Menucomponent from '../components/MenuComponent';
    const axios = require('axios');
    export default {
        name: "ShowComponent",
        //show the menu
        components: {Menucomponent},
        //data needed, the name of the show that this component getd from RecommendComponent or IndexComponent
        props: {
            series_name: {
                type: String,
                required: true
            }
        },
        data() {
            return {
                /**
                 * a single show loaded from the database containing its name, genres, votes and rating
                 */
                show: {},
                /**
                 * a single show description loaded from themoviedb.org
                 */
                info: ''
            }
        },
        methods: {
            /**
             * Loads show details from the database
             * @return {Object} show objects (series_name, votes and rating for the show)
             */
            loadShow() {
                /* eslint-disable no-console */
                var name = this.series_name;
                var uri = "http://localhost:3000/api/show/?series_name=" + name;
                axios
                    .get(uri)
                    .then(responce => {
                        this.show = responce.data;
                        this.getDescription();
                    })
                    .catch(err => {
                        console.log(err);
                    });
            },

            /**
             * Loads show details from the themoviedb.org webpage
             */
            getDescription() {
                var name = this.series_name;
                var uri = "https://api.themoviedb.org/3/search/tv?api_key=7d23aafdf005feaeec6939b430e5e4e4&language=en-US&query=" + name + "&page=1";
                axios
                    .get(uri)
                    .then(responce => {
                        var resultShow = responce.data.results[0];
                        this.info = resultShow.overview;
                        var poster = document.getElementById("poster");
                        poster.src="https://image.tmdb.org/t/p/w500" + resultShow.poster_path;
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
