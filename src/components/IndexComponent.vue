<template>
    <div class="row justify-content-center">
        <menu-component></menu-component>
        <div class="col-md-8">
            <h1>All shows</h1>
            <table class="table table-striped" v-if="hasShows">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Votes</th>
                    <th>Rating</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="show in shows" :key="show.series_name" >
                    <td><router-link :to="{name: 'show', params: {series_name: show.series_name}}">{{ show.series_name }}</router-link> </td>
                    <td>{{ show.votes }} </td>
                    <td>{{ show.rating | numFormat('0.00') }}</td>
                </tr>
                </tbody>
            </table>
            <p v-if="noShows">No shows yet!</p>
        </div>
    </div>
</template>

<script>
    //import the menu
    import MenuComponent from '../components/MenuComponent';
    const axios = require('axios');
    export default {
        name: "app",
        //show the menu
        components: {MenuComponent},
        //data for the ShowComponent - the name of the show
        props:['show.series_name'],
        computed: {
            //boolean hasShows - show the table if there are shows
            /**
             * @type {boolean}  boolean flag  - show the table if there are shows
             */
            hasShows() {
                return this.isLoading === false && this.shows.length > 0;
            },
            //boolean noShows - don't show the table, show the "No shows yet' message
            /**
             * @type {boolean}  boolean flag  - don't show the table, show the "No shows yet' message
             */
            noShows() {
                return this.isLoading === false && this.shows.length === 0;
            }
        },
        data() {
            return {
                /**
                 * a singular show loaded from the database containing its name, votes and rating
                 */
                show: {
                    series_name: '',
                    votes: '',
                    rating: '',
                },
                /**
                 * @type {[]}  array for shows loaded from the database
                 */
                shows: [],
                isLoading: true,
            }
        },

        methods:{
            /**
             * Loads all shows from the database
             * @return [] list of show objects (series_name, votes and rating for each show)
             */
            loadShows() {
                axios
                    .get( "http://localhost:3000/api/all_shows")
                    .then( responce => {
                        this.isLoading = false;
                        this.shows = responce.data;
                    } )
                    .catch( err => {
                        throw( err );
                    } );
            }
        },
        mounted() {
            return this.loadShows();
        }
    }
</script>
