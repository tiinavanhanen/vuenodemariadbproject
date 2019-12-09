<template>
    <div class="row justify-content-center">
        <menu-component></menu-component>
        <div class="col-md-8">
            <h1>Add a show</h1>
            <form @submit.prevent="addSeries">
                <label>Series name</label>
                <input id="showname" type="text" v-model="series.series_name"/>
                <button>Add series</button>
                <p v-if="success" class="success-message">
                    ✅ Series successfully added
                </p>
                <p v-if="check" class="error-message">
                    ❗Series is already on your list
                </p>
                <p v-if="error" class="error-message">
                    ❗We could not find a series by this name
                </p>
                <p v-if="isNegative" class="error-message">
                    ❗Both season and episode must be positive numbers
                </p>
            </form>
        </div>
        <div class="col-md-8" id="ownseries">
            <p v-if="shows.length < 1" class="empty-table">
                No series yet
            </p>
            <table class="table table-striped" v-else>
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Season</th>
                    <th>Episode</th>
                    <th v-if="editing !== null">Rating</th>
                </tr>
                </thead>
                <tbody>
                <tr :key="show.series_name" v-for="show in shows">
                    <td>{{show.series_name}}</td>
                    <td v-if="editing === show.series_name">
                        <input type="number" min="1" v-model="show.season">
                    </td>
                    <td v-else>{{show.season}}</td>
                    <td v-if="editing === show.series_name">
                        <input type="number" min="1" v-model="show.episode">
                    </td>
                    <td v-else>{{show.episode}}</td>
                    <td v-if="editing === show.series_name">
                        <v-select v-model="show.score" :options="options" placeholder="">
                        </v-select>
                    </td>
                    <td v-if="editing === show.series_name">
                        <button @click="editSeries(show)">Save</button>
                        <button class="muted-button" @click="cancelEdit(show)">Cancel</button>
                    </td>
                    <td v-else>
                        <button @click="editMode(show)">Edit</button>
                        <button @click="deleteSeries(show)">Delete</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script>
    import MenuComponent from '../components/MenuComponent';
    const axios = require('axios');
    export default {
        name: "app",
        components: {MenuComponent},
        data() {
            return {
                /**
                 * @type {boolean}  boolean flag to indicate success in adding a series to the database
                 */
                success: false,
                /**
                 * @type {boolean}  boolean flag to indicate failure in adding a series to the database
                 */
                error: false,
                /**
                 * @type {boolean}  boolean flag to indicate that the series is already on the current user's table
                 */
                check: false,
                /**
                 * @type {Object} the name of a series the user types into the search
                 */
                series: {
                    series_name: '',
                },
                /**
                 * @type {Object} a singular show loaded from the database containing its name, season, episode, and score
                 */
                show: {
                    series_name: '',
                    season: '',
                    episode: '',
                    score: '',
                },
                /**
                 * @type {[]} array for shows loaded from the database
                 */
                shows: [],
                /**
                 * @type {[]} array containing rating options
                 */
                options: [1,2,3,4,5],
                /**
                 * @type {series_name} the name of the series being edited
                 */
                editing: null,
                /**
                 * @type {boolean} boolean flag to indicate that either the season or the episode is negative
                 */
                isNegative: false,
            }
        },
        methods: {
            /**
             * Called when the user clicks the add series button
             * Adds the series the user inputted into the form to the database
             */
            addSeries() {
                // eslint-disable-next-line no-console
                console.log("lisätään sarjaa");
                const body = {
                    "showname": this.series.series_name,
                    "loggedUser": localStorage.getItem('username'),
                };
                // eslint-disable-next-line no-console
                console.log(body.loggedUser);
                var uri = "http://localhost:3000/api/addseries/?showname=" + body.showname + "&username=" + body.loggedUser;
                axios
                    .get(uri)
                    .then(response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        if (response.data === "already on list") {
                            this.check = true;
                            this.success = false;
                            this.error = false;
                        } else if (response.data === "series added") {
                            this.success = true;
                            this.check = false;
                            this.error = false;
                            this.series.series_name = '';
                            this.loadShows();
                        } else if (response.data === "series not found") {
                            this.error = true;
                            this.check = false;
                            this.success = false;
                        }
                    });
            },
            /**
             * Called when the page loads
             * Loads all shows from the current logged user's table in the database
             */
            loadShows() {
                var loggedUser = localStorage.getItem('username');
                axios
                    .get("http://localhost:3000/api/ownseries/?username=" + loggedUser)
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.shows = response.data;
                        // eslint-disable-next-line no-console
                        console.log(this.shows);
                    });
            },
            /**
             * Called when the user clicks the update button in edit mode
             * Updates the season, episode and rating of the series in the database
             * @param {show} show the series to be edited
             */
            editSeries(show) {
                var loggedUser = localStorage.getItem('username');
                if (show.series_name === '' || show.season === '' || show.episode === '') return;
                if (show.season < 1 || show.episode < 1) {
                    this.isNegative = true;
                } else {
                    this.isNegative = false;
                    // eslint-disable-next-line no-console
                    console.log("editing series: " + JSON.stringify(show));
                    // eslint-disable-next-line no-console
                    console.log("komponentissa name, score " + show.series_name + show.score);
                    axios
                        .get("http://localhost:3000/api/editseries/?username=" + loggedUser + "&showname=" + show.series_name +
                            "&season=" + show.season + "&episode=" + show.episode + "&score=" + show.score)
                        .then( response => {
                            // eslint-disable-next-line no-console
                            console.log(response);
                            this.editing = null;
                            this.loadShows();
                        });
                }
            },
            /**
             * Called when the user clicks the delete button in edit mode
             * Deletes the series from the current logged user's table in the database
             * @param {show} show the series to be deleted
             */
            deleteSeries(show) {
                var loggedUser = localStorage.getItem('username');
                // eslint-disable-next-line no-console
                console.log("deleting series: " + JSON.stringify(show));
                axios
                    .get("http://localhost:3000/api/deleteseries/?username=" + loggedUser + "&showname=" + show.series_name)
                    .then( response => {
                        // eslint-disable-next-line no-console
                        console.log(response);
                        this.loadShows();
                    });
            },
            /**
             * Called when the user clicks the edit button
             * Enables the editing of series on the current logged user's table
             * @param {show} series the series the user clicked and wishes to edit or delete
             */
            editMode(series) {
                this.cachedSeries = Object.assign({}, series);
                this.editing = series.series_name;
                // eslint-disable-next-line no-console
                console.log("cached series: " + JSON.stringify(series));
            },
            /**
             * Called when the user clicks the cancel button in edit mode
             * Cancels all edits done in edit mode and exits edit mode
             * @param {show} series the user clicked and wished to edit or delete
             */
            cancelEdit(series) {
                Object.assign(series, this.cachedSeries);
                this.editing = null;
                // eslint-disable-next-line no-console
                console.log("retrieved from cache series: " + JSON.stringify(series));
            },
        },
        mounted() {
            return this.loadShows();
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
    #showname {
        margin: 0.5em;
    }
</style>
