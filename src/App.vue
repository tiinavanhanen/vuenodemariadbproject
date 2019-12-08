<template>
  <div class="container">

    <nav class="navbar navbar-expand-sm bg-dark navbar-dark" >
      <ul class="navbar-nav">
        <template v-if="loggedUser === null">
          <li class="nav-item">
            <router-link to="/" class="nav-link">Home</router-link>
          </li>
        </template>

        <template v-else>
          <li class="nav-item">
            <router-link to="/addseries" class="nav-link">Add series</router-link>
          </li>
          <li class="nav-item" >
            <router-link to="/posts" class="nav-link">All shows</router-link>
          </li>
          <li class="nav-item">
            <router-link to="/comments" class="nav-link">Comments</router-link>
          </li>
          <li class="nav-item">
            <router-link to="/recommend" class="nav-link">Recommendations</router-link>
          </li>
          <li class="nav-item">
            <button v-on:click="logout">Log out</button>
          </li>
        </template>
      </ul>
    </nav>
    <br />
    <transition name="fade">
      <router-view></router-view>
    </transition>
  </div>
</template>

<style>
  .fade-enter-active, .fade-leave-active {
    transition: opacity .5s
  }
  .fade-enter, .fade-leave-active {
    opacity: 0
  }
</style>

<script>
  export default {
    data(){
      return{
        loggedUser: localStorage.getItem('username')
      }
    },
    methods: {
      /**
       * Gets called when the "Log out" button is pressed in order to log out
       */
      logout() {
        /* eslint-disable no-console */
        console.log("log out");
        localStorage.clear();
        this.loggedUser = null;
        this.$router.push('/');
      }
    }
  }
</script>
